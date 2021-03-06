alias dbuild='docker build -f Dockerfile . --tag rcon'
alias r='docker run -e PASSWORD=a -p 8787:8787 -v ~/bios611-project1:/home/rstudio/ rcon'
alias b='docker run -v `pwd`:/home/rstudio -e PASSWORD=not_important -it rcon sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"'
alias shiny='docker run -p 8788:8788 -v `pwd`:/home/rstudio -e PASSWORD=shinyshrooms -it rcon sudo -H -u rstudio /bin/bash -c "cd ~/; PORT=8788 make shiny"'