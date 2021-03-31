RESOURCE_DIR = "Resources"
UPLOAD_DIR = "#{ENV['HOME']}/Dropbox/Shared/GolfApp"
IGNORE = ['.svn','.DS_Store','.idea','build']
APP_DIR = "#{ENV['TARGET_BUILD_DIR']}/#{ENV['EXECUTABLE_FOLDER_PATH']}"
verbose(true)

#raise "Needs variables" unless defined? TARGET_BUILD_DIR

task :demo_build do
  xcode("build","Development")
  #sh 'codesign', '--verify', '-vv', "build/Release-iphoneos/Golf.app/Golf"
end

task :demo_source do
	dest = "#{UPLOAD_DIR}/Leveranser/GolfAppSource"
	mkdir_p dest
	sh "svn info > svninfo.txt"
	rsync("./",dest,true)
end

desc "Release and upload"
task :demo => [:demo_build,:demo_source] do
  dest = "#{UPLOAD_DIR}/Leveranser"
  rsync("build/Development-iphoneos/GolfTech.app", dest, true)
  rsync("build/Development-iphoneos/Short Game.app", dest, true)
  #cp "Golf_Clinic_Short_Game.mobileprovision", dest
  cp "Leverans.txt", dest
end

desc "Clean"
task :clean do
  xcode("clean","Development")
end

desc "Set langague to Swedish"
task :sv do
	IGNORE << 'en.lproj'
end

desc "Set langague to English"
task :en do
	IGNORE << 'sv.lproj'
end

desc "Copy resources into app"
task :resources do
  rsync("#{RESOURCE_DIR}/",APP_DIR,false)
end

def xcode(task,config)
  sh "xcodebuild -project Golf.xcodeproj -target All -configuration #{config} -sdk iphoneos #{task}"
end

def rsync(source,target,delete)
  rsync="rsync --archive --rsh ssh --verbose #{exluded('--exclude')}"
  flag = delete ? "--delete" : ""
  sh %Q{#{rsync} #{flag} '#{source}' '#{target}'}
end

def exluded(parametername)
  return "#{IGNORE.map { |x| "#{parametername} #{x} " }.join(' ')}"
end

