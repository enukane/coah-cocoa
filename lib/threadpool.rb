require 'thread'

class ThreadPool
  def initialize(max_size, max_job=nil)
    @th_group = ThreadGroup.new
    @pool = []
    @max_size = max_size
    @pool_mutex = Mutex.new
    @pool_cv = ConditionVariable.new
    @max_job =  max_job
    @job_count = 0
  end

  def dispatch(num, list)

    Thread.new do
      @pool_mutex.synchronize do
        while @pool.size >= @max_size
          p "Pool is full: page #{num} waits\n" if $DMSG
          @pool_cv.wait(@pool_mutex)
        end
      end

      @pool << Thread.current
      @job_count+=1
      p "#{@pool.size}" if $DMSG

      begin
        yield(num, list[num])
      rescue => e
        exception(self, e, list[num])
      ensure
        @pool_mutex.synchronize do
          @pool.delete(Thread.current)
          @pool_cv.signal
        end
      end
    end
  end

  def shutdown 
    @pool_mutex.synchronize do
      @pool_cv.wait(@pool_mutex) until @pool.empty?
    end
  end

  def join
    while !@pool.empty? || is_jobs? do
      @pool_mutex.synchronize do
        @pool_cv.wait(@pool_mutex)
      end
    end
  end

  def is_jobs?
    unless @max_job then
      return true
    end

    if @job_count < @max_job then
      return true
    end

    return false
  end

  def exception(thread, exception, *original_args)
    puts "Exception in thread #{thread} : #{exception}"
  end
end
