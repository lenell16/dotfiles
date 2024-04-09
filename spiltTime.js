const fs = require("fs");
const path = require("path");

if (process.argv.length < 5) {
  console.log("Usage: node <script> <sourceDir> <olderDir> <newerDir>");
  process.exit(1);
}

// Read directories from command line arguments
const [sourceDir, olderDir, newerDir] = process.argv
  .slice(2)
  .map((dir) => path.resolve(dir));

// Check if source directory exists
fs.access(sourceDir, fs.constants.F_OK, (err) => {
  if (err) {
    console.error(`Source directory does not exist: ${sourceDir}`);
    process.exit(1);
  }

  // Ensure older and newer directories exist, create them if they don't
  [olderDir, newerDir].forEach((dir) => {
    fs.access(dir, fs.constants.F_OK, (err) => {
      if (err) {
        // Directory does not exist, so create it
        fs.mkdir(dir, { recursive: true }, (err) => {
          if (err) {
            console.error(`Failed to create directory: ${dir}`);
            process.exit(1);
          }
          console.log(`Directory created: ${dir}`);
        });
      }
    });
  });

  // Function to move files
  const moveFile = (sourcePath, destinationPath) => {
    fs.rename(sourcePath, destinationPath, (err) => {
      if (err) throw err;
      console.log(`Moved: ${sourcePath} -> ${destinationPath}`);
    });
  };

  // Read and process the source directory
  fs.readdir(sourceDir, { withFileTypes: true }, (err, files) => {
    if (err) throw err;

    files.forEach((file) => {
      const filePath = path.join(sourceDir, file.name);
      fs.stat(filePath, (err, stats) => {
        if (err) throw err;

        const now = Date.now();
        const creationTime = new Date(stats.birthtime).getTime();
        const ageMinutes = (now - creationTime) / (1000 * 60);

        if (ageMinutes > 20) {
          // Move file or folder older than 20 minutes
          moveFile(filePath, path.join(olderDir, file.name));
        } else {
          // Move file or folder newer than 20 minutes
          moveFile(filePath, path.join(newerDir, file.name));
        }
      });
    });
  });
});
