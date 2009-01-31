#!/usr/bin/env ruby


# This is just a dumb container for video meta dataType
# Any of this attributes can be empty
class MetaData

    attr_accessor :fileName,        # The file name and path of the movie
					:dataType,      # Data type (RIFF, endian-ess)
					:container,     # The container type, mkv, avi, etc
					:resolution,    # The image and width of the movie
					:fps,           # How many frames per second, common values might be 23.98, 25.00 or 29.97
					:videoFormat,   # The format of the video, DivX, Xvid, etc
					:audioFormat,   # The format of the sound, MP#, AAC, etc
					:audioSampling  # Audo recording settings, such as stereo, number of channels, khz


	def to_s
		info = ""
		info << "File name:      #{@fileName}\n"
		info << "Data type:      #{@dataType}\n"
		info << "Container:      #{@container}\n"
		info << "Resolution:     #{@resolution}\n"
		info << "Frames/sec:     #{@fps}\n"
		info << "Video format:   #{@videoFormat}\n"
		info << "Audio format:   #{@audioFormat}\n"
		info << "Audio sampling: #{@audioSampling}\n"

		return info
	end
end


class Extracter
	def getFileList(grokPattern = "*")
		list = Array.new
		list << "1984.avi"
	end

	def getRawMetaData(fileList)
		metaDataList = Array.new

		metaDataList << "/mnt/Angelix/MotionPictures/Movies/1984.avi: RIFF (little-endian) data, AVI, 512 x 384, 29.97 fps, video: DivX 5, audio: MPEG-1 Layer 3 (stereo, 48000 Hz)"
#		metaDataList << "/mnt/Angelix/MotionPictures/Movies/Goya's Ghosts (1 of 2).avi: RIFF (little-endian) data, AVI, 560 x 304, 25.00 fps, video: XviD, audio: Dolby AC3 (6 channels, 48000 Hz)"
		return metaDataList
	end


	# Returns a hah list of MediaData instances, keyed on the file name
	def parseRawMetaData(rawDataList)
		mediaDataList = Hash.new

		rawDataList.each do |rawData|
			fileName      = "1984.avi"
			dataType      = "RIFF (little-endian) data"
			container     = "AVI"
			resolution    = "512 x 384"
			fps           = "29.97"
			videoFormat   = "DivX 5"
			audioFormat   = "MPEG-1 Layer 3"
			audioSampling = "stereo, 48000 Hz"

			mdInstance = MetaData.new
			mdInstance.fileName      = fileName
			mdInstance.dataType      = dataType
			mdInstance.container     = container
			mdInstance.resolution    = resolution
			mdInstance.fps			 = fps
			mdInstance.videoFormat   = videoFormat
			mdInstance.audioFormat   = audioFormat
			mdInstance.audioSampling = audioSampling

			mediaDataList[fileName] = mdInstance
		end

		return mediaDataList
	end
end





### WORK ###

extracter = Extracter.new

fileList = extracter.getFileList("*.avi")
rawList  = extracter.getRawMetaData(fileList)

metadataInstanceList = extracter.parseRawMetaData(rawList)

puts metadataInstanceList

