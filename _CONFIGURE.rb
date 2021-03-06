module Pod
  class TemplateCofigurator

    attr_reader :pod_name

    def initialize(pod_name)
      @pod_name = pod_name
    end

    def run
      puts "Configuring #{pod_name}"
      print_info
      clean_template_files
      replace_variables_in_files
      rename_template_files
      reinitialize_git_repo
    end

    #----------------------------------------#

    def print_info
      puts "user name:#{user_name}"
      puts "user email:#{user_email}"
      puts "year:#{year}"
    end

    def clean_template_files
      `rm -rf ./**/.gitkeep`
      `rm -rf _CONFIGURE.rb`
      `rm -rf README.md`
    end

    def replace_variables_in_files
      file_names = ['LICENSE',
                    'POD_README.md',
                    'CHANGELOG.md',
                    'NAME.podspec',
                    'Podfile',
                    'UnitTests/UnitTests.m']
      file_names.each do |file_name|
        text = File.read(file_name)
        text.gsub!("${POD_NAME}", pod_name)
        text.gsub!("${USER_NAME}", user_name)
        text.gsub!("${USER_EMAIL}", user_email)
        text.gsub!("${YEAR}", year)
        text.gsub!("${DATE}", date)
        File.open(file_name, "w") { |file| file.puts text }
      end
    end

    def rename_template_files
      `mv POD_README.md README.md`
      `mv NAME.podspec #{pod_name}.podspec`
    end

    def reinitialize_git_repo
      `rm -rf .git`
      `git init`
      `git add -A`
      `git commit -m "Initial commit"`
    end

    #----------------------------------------#

    def user_name
      (ENV['GIT_COMMITTER_NAME'] || `git config user.name`).strip
    end

    def user_email
      (ENV['GIT_COMMITTER_EMAIL'] || `git config user.email`).strip
    end

    def year
      Time.now.year.to_s
    end

    def date
      Time.now.strftime "%m/%d/%Y"
    end

    #----------------------------------------#
  end
end

#-----------------------------------------------------------------------------#

# TODO: Handle Pod name
# TODO: Handle author name
# TODO: Handle license details
# TODO: Provide project

pod_name = ARGV.shift
Pod::TemplateCofigurator.new(pod_name).run

