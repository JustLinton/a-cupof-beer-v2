 #!/bin/bash
hugo
git add .
git commit -m "auto-commit"
git push origin master
