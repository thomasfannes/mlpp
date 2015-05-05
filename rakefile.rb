$build_type=:debug

namespace :test do
    def fff_all_tests(*options)
        libs = %w[boost_system boost_program_options].map{|lib|"c++.library:#{lib}"}*' '
        FileList.new('**/test/*.cpp').each do |fn|
            sh "fff c++.tree:mlpp #{libs} #{fn} #{options*' '}"
        end
    end
    task :build do
        fff_all_tests('norun', $build_type, 'clang')
    end
    task :run do
        fff_all_tests($build_type, 'clang')
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
