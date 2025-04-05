const fs = require('fs');

const directoryPath = 'sound/announcer/vox_male/'; // Path to vox audio files, from
const directoryPathList = `../../` // Extra text prepended to directoryPath when getting the directory list (make it go to the root directory of the codebase)

const pathToVoxSounds = `../../code/modules/mob/living/silicon/ai/vox_sounds.dm` // The path to vox_sounds.dm (starting from this file's directory)

// Use fs.readdirSync to read the contents of the directory synchronously
const fileList = fs.readdirSync(directoryPathList + directoryPath);

var fileContents = `// List is required to compile the resources into the game when it loads.
// Dynamically loading it has bad results with sounds overtaking each other, even with the wait variable.
#ifdef AI_VOX

// Regex for collecting a list of ogg files
// (([a-zA-Z,.]+)\\.ogg)

// For vim
// :%s/\\(\\(.*\\)\\.ogg\\)/"\\2" = 'sound\/vox_fem\\/\\1',/g
GLOBAL_LIST_INIT(vox_sounds, list(
`

//console.log('Files and folders in the directory:', fileList);
let i = 0

while (i < fileList.length) {
	var old = fileList[i]
	fileList[i] = fileList[i].replace("'", "\\'").replace("_", "\\_").replace(/[^a-z\/.]/gm, "")

	if (fileList[i] != old) {
		i++;
		continue
	}

	var voxName = fileList[i].replace(".ogg", "")
	if (voxName == "_comma") voxName = ","
	if (voxName == "_period") voxName = "."

	fileContents += `	"${voxName}" = '${directoryPath}${fileList[i]}',
`

	console.log(fileList[i])
	i++
}

fileContents += `))
#endif`

fs.writeFileSync(pathToVoxSounds, fileContents);

console.log("Done!")
