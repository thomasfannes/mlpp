$compiler = ENV['CC'] || "g++"
$build_type = ENV['BUILD_TYPE'] || "debug"
$verbose = ENV['VERBOSE'] != nil


$library_dirs=%w[/home/thomasf/boost/lib]
$libs = %w[boost_system boost_program_options]
$include_paths = %w[mlpp]


namespace :test do
	def executeCommand(cmd)
		output = ""
		IO.popen(cmd + " 2>&1") do |io|
			while line = io.gets
				output += line.chomp!
			end
			
			io.close
			return output, $?.to_i
		end
	end

    def write_command_output(command, output)
	if $verbose
	        puts "Command: " + command
		puts output
	end
    end
	
    def fff_all_tests(execute_tests)
		$stdout.sync = true
		
        libs = $libs.map{ |lib| "c++.library:#{lib}"}*' '
        include_paths = $include_paths.map{ |path| "c++.tree:#{path}"}*' '
        library_dirs = $library_dirs.map{ |dir| "c++.library_path:#{dir}"}*' '
        
        execTestMSG = execute_tests ? "Build and executed " : "Build "
        
        FileList.new('**/test/*.cpp').each do |fn|
			executableTest = fn.pathmap("%f").start_with?("no_") ? false : true

			
			command = "fff #{libs} #{include_paths} #{library_dirs} #{fn} #{$compiler} #{$build_type}" + ( (execute_tests and executableTest) ? "" : " norun")
			output,code = executeCommand(command)
			write_command_output(command, output)


	
			if (code == 0) == executableTest
			    puts "Test '#{fn}': Passed"
			else
			    fail "Test '#{fn}' failed"
			end
        end
    end
    
    task :build do ||
        fff_all_tests(false)
    end
    
    task :run do
        fff_all_tests(true)
    end
end

task :test => 'test:run'

namespace :qtcreator do
    task :create_files do
        File.open('mlpp.files', 'w') do |fo|
            %w[hpp hxx cpp].each do |ext|
                FileList.new("**/*.#{ext}").each do |fn|
                    fo.puts(fn)
                end
            end
        end
    end
end
