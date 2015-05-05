$build_type=:debug
$library_dir="/home/thomasf/boost/lib"

namespace :test do
    def fff_all_tests(*options)
        libs = %w[boost_system boost_program_options].map{|lib|"c++.library:#{lib}"}*' '
        FileList.new('**/test/*.cpp').each do |fn|
            sh "fff c++.tree:mlpp #{libs} #{fn} #{options*' '} c++.library_path:#{$library_dir}"
        end
    end
    task :build do
        fff_all_tests('norun', $build_type)
    end
    task :run do
        fff_all_tests($build_type)
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
