const fs = require("fs");
const path = require("path");

let movedFilesCount = 0; // Variable to keep track of the total moved files

// Retrieve the directory path from command-line arguments
const targetDirectory = process.argv[2];
const outputDirectory = process.argv[3];

if (!targetDirectory) {
  console.error("Please provide a directory path as a command argument.");
  process.exit(1);
}

// Regex pattern
const patterns = [
  /([\w|.]*)_(\d+_\d+_\d+_n|\d+_\d+_\d+)( \(\d+\))?.(jpg|mp4|heic|webp|jpeg)/,
  /([\w|.]*)_(\d+_\d+_\d+_n|\d+_\d+_\d+)(-\d+).(jpg|mp4|heic|webp|jpeg)/,
  /([\w|.]*)_(\d+)( \(\d+\))?.(jpg|mp4|heic|webp|jpeg)/,
  /([\w|.]*)_(\d+)(-\d+).(jpg|mp4|heic|webp|jpeg)/,
  /^([\w|.]*)'s [\w\W()]+.(jpg|mp4|heic|webp|jpeg)$/,
  /^([\w|.]*)_\w+_video_dashinit( \(\d+\))?.mp4/,
];

// Read the directory
fs.readdir(targetDirectory, (err, files) => {
  if (err) {
    console.error(`Failed to read the directory: ${err.message}`);
    return;
  }

  files.forEach((file) => {
    let match;
    for (let i = 0; i < patterns.length; i++) {
      match = file.match(patterns[i]);
      if (match) {
        break;
      }
    }

    if (match) {
      const folderName = match[1];
      const folderPath = path.join(outputDirectory, folderName);

      // Check if the folder exists, if not create it
      if (!fs.existsSync(folderPath)) {
        fs.mkdir(folderPath, { recursive: true }, (err) => {
          if (err) {
            console.error(`Failed to create the directory: ${err.message}`);
            return;
          }
          moveFile(file, folderPath);
        });
      } else {
        moveFile(file, folderPath);
      }
    }
  });
});

function moveFile(file, folderPath) {
  const srcPath = path.join(targetDirectory, file);
  const destPath = path.join(folderPath, file);

  // Move the file
  fs.rename(srcPath, destPath, (err) => {
    if (err) {
      console.error(`Failed to move the file: ${err.message}`);
      return;
    } else {
      movedFilesCount++;
    }
    console.log(`Moved file #: ${movedFilesCount}`);
    console.log(`Moved ${file} to ${folderPath}`);
  });
}
