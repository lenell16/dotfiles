const fs = require("fs");
const path = require("path");

const rootDir = process.argv[2] || __dirname; // Use the specified directory or the current directory if none is specified
const targetDirName = "mergedDirectory"; // Name of the directory where all files will be merged
const targetDirPath = path.join(rootDir, targetDirName);

// Create the target directory if it doesn't exist
if (!fs.existsSync(targetDirPath)) {
  fs.mkdirSync(targetDirPath);
}

// Function to move files from source to target directory
const moveFiles = (sourceDir, targetDir) => {
  fs.readdir(sourceDir, { withFileTypes: true }, (err, files) => {
    if (err) {
      console.error(`Error reading directory ${sourceDir}: `, err);
      return;
    }
    files.forEach((file) => {
      const sourcePath = path.join(sourceDir, file.name);
      const targetPath = path.join(targetDir, file.name);
      fs.rename(sourcePath, targetPath, (err) => {
        if (err) console.error(`Error moving file ${file.name}: `, err);
        else console.log(`Moved ${sourcePath} to ${targetPath}`);
      });
    });
  });
};

// Search and process directories matching the pattern
fs.readdir(rootDir, { withFileTypes: true }, (err, entries) => {
  if (err) {
    console.error("Failed to read directory:", err);
    return;
  }

  entries.forEach((entry) => {
    if (entry.isDirectory() && /\d{19}/.test(entry.name)) {
      const dirPath = path.join(rootDir, entry.name);
      console.log(`Merging directory: ${dirPath}`);
      moveFiles(dirPath, targetDirPath);
    }
  });
});
