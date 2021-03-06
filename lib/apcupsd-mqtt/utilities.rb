require 'timeout'

class Utilities

  # thanks to https://stackoverflow.com/a/31465248/1387396

  def self.exec_with_timeout(cmd, timeout)
    begin
      # stdout, stderr pipes
      rout, wout = IO.pipe
      rerr, werr = IO.pipe
      stdout, stderr = nil

      pid = Process.spawn(cmd, pgroup: true, :out => wout, :err => werr)

      Timeout.timeout(timeout) do
        Process.waitpid(pid)

        # close write ends so we can read from them
        wout.close
        werr.close

        stdout = rout.readlines.join
        stderr = rerr.readlines.join
      end

    rescue Timeout::Error
      Process.kill(-9, pid)
      Process.detach(pid)
      raise
    ensure
      wout.close unless wout.closed?
      werr.close unless werr.closed?
      # dispose the read ends of the pipes
      rout.close
      rerr.close
    end
    stdout
   end

end
