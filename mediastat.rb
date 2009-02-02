#!/usr/bin/env ruby


require 'find'
require 'pathname'

# This is just a dumb container for video meta dataType
# Any of this attributes can be empty
class MetaData

    attr_accessor :fileName,         # The file name
    				:path,           # The file name and path of the movie
					:dataType,       # Data type (RIFF, endian-ess)
					:container,      # The container type, mkv, avi, etc
					:width,          # The image width of the movie
					:height,         # The image height of the movie
					:fps,            # How many frames per second, common values might be 23.98, 25.00 or 29.97
					:videoFormat,    # The format of the video, DivX, Xvid, etc
					:audioFormat,    # The format of the sound, MP3, AAC, etc
					:audioSampling,  # Audo recording settings, such as stereo, number of channels, khz
					:runtime         # The number of minutes the movie is


	def to_s
		info = ""
		info << "File name:      #{@fileName}\n"
		info << "Data type:      #{@dataType}\n"
		info << "Container:      #{@container}\n"
		info << "Width:          #{@width}\n"
		info << "Height:         #{@height}\n"
		info << "Frames/sec:     #{@fps}\n"
		info << "Video format:   #{@videoFormat}\n"
		info << "Audio format:   #{@audioFormat}\n"
		info << "Audio sampling: #{@audioSampling}\n"

		return info
	end
end


class Extracter

	def initialize()
		@approvedMediaType = Array.new
		@approvedMediaType << ".avi"
		@approvedMediaType << ".mov"
		@approvedMediaType << ".mpg"
		@approvedMediaType << ".mpeg"
		@approvedMediaType << ".divx"
		@approvedMediaType << ".xvid"
		@approvedMediaType << ".h264"
		@approvedMediaType << ".wmv"
		@approvedMediaType << ".flv"
	end

	def getFileList(dirPath)
		list = Array.new
		Find.find(dirPath) do |file|
			baseName = File.basename(file)

			if (FileTest.directory?(file))
				next
			end

			if baseName =~ /^\./
				next
			end

			if (not @approvedMediaType.include?(File.extname(baseName)))
				# puts "Notice: The file '#{baseName}' is not of a approved list."
				next
			end
			path = Pathname.new(file)

			# This gives the real path, an absolute path where symlinks has been fully resolved
			list <<  path.realpath.to_s

			# This gives you the path
			#list << file
		end

		return list
	end

	def getMetaData(fileList)
		rawMetaDataList = Hash.new

		media = fileList[20]
#		fileList.each do |media|
			#metaDataList[media] = `file "#{media}"`
			rawData = `mplayer -identify -frames 0 "#{media}" 2> /dev/null | grep ID`
			parseMetaData(rawData)
#		end

		#return metaDataList
	end


	### ID_VIDEO_FORMAT
	#	0x10000001 = MPEG1
	#	0x10000002 = MPEG2
	#	0x10000004 = MPEG4

	# Returns an instance of MetaData class, filled with values
	def parseMetaData(rawData)
		mdInstance = MetaData.new

		rawData.each do |data|
			key, value = data.split("=")
			if (key.nil? || value.nil?)
				next
			end

			key.strip!
			value.strip!

			puts "#{key}     #{value}"

			case key
				when "ID_FILENAME"     then mdInstance.fileName    = File.basename(value); mdInstance.path = value; mdInstance.container = parseContainer(value)
				when "ID_LENGTH"       then mdInstance.runtime     = value

				when "ID_VIDEO_WIDTH"  then mdInstance.width       = value
				when "ID_VIDEO_HEIGHT" then mdInstance.height      = value
				when "ID_VIDEO_FPS"    then mdInstance.fps         = value
				when "ID_VIDEO_FORMAT" then mdInstance.videoFormat = parseVideoFormat(value)
			end

		end

		return mdInstance
	end

	def parseVideoFormat(videoFormat)
		case videoFormat
			when "0x10000001" then return "MPEG-1"
			when "0x10000002" then return "MPEG-2"
			when "0x10000004" then return "MPEG-4"
		end

		return videoFormat
	end

	def parseContainer(fileName)
		fileExtension = File.extname(fileName)
		return fileExtension.gsub(/^\./, '').upcase
	end
end





### WORK ###

extracter = Extracter.new

#fileList = extracter.getFileList("/home/jonix/Angelix/MotionPictures/Videos")
fileList = extracter.getFileList("../../Angelix/MotionPictures/Movies/")

rawList  = extracter.getMetaData(fileList)

#p rawList

puts rawList.to_s

#metadataInstanceList = extracter.parseRawMetaData(rawList)

#puts metadataInstanceList

