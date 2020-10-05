alias r='docker run -e PASSWORD=a -p 8787:8787 -v ~/bios611-project1:/home/rstudio/ rcon'
alias dbuild='docker build -f Dockerfile . --tag rcon'