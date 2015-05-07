$build_type=:debug
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
	
    def fff_all_tests(execute_tests)
		$stdout.sync = true
		
        libs = $libs.map{ |lib| "c++.library:#{lib}"}*' '
        include_paths = $include_paths.map{ |path| "c++.tree:#{path}"}*' '
        library_dirs = $library_dirs.map{ |dir| "c++.library_path:#{dir}"}*' '
        
        execTestMSG = execute_tests ? "Building and executing " : "Building "
        
        FileList.new('**/test/*.cpp').each do |fn|
			executableTest = fn.pathmap("%f").start_with?("no_") ? false : true
			
			if executableTest
				print execTestMSG + "test '#{fn}': "
			else
				print "Building noncompilable test '#{fn}': "
			end
						
			command = "fff #{libs} #{include_paths} #{library_dirs} #{fn}" + ( (execute_tests and executableTest) ? "" : " norun")
			output,code = executeCommand(command)
					
			if (code == 0) == executableTest
				puts "OK"
			else
				if executableTest
					puts "Failed"
					puts output
				else
					puts "Able to compile"
				end	
				fail "Test failed"
			end
        end
    end
    
    task :build do
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
