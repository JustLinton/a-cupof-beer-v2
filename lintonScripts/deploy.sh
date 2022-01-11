 #!/bin/bash
hugo
cd public
git add .
git commit -m "r"
git push dep master
