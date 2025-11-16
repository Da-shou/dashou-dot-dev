# dashou-dot-dev

## Simple blogging platform to post updates about my work.

### Summary

This is a small web developement project where I will do my best to create a functional blogging platform to post updates about my projects. 
The main website will contain a quick presentation of me and my interests, and contain a list of the different projects I have worked on and/or have finished working on. 
The blog post will contain titles, tags, summaries, content (text, images, videos, audio) and comment space.
One of the goals of this project is to have a very fast and dynamic website, that loads as fast as possible to get the smoothest experience possible.

### Technologies

| *Part*      | *Technology*                | *Why*                                                                                         |
|-------------|-----------------------------|-----------------------------------------------------------------------------------------------|
| Back-end    | Javascript, using ExpressJS | Fast and quick to setup.                                                                      |
| Front-end   | HTML5 + CSS3                | I wish to keep things as simple as possible and focus on the content.                         |
| Database    | SQLite                      | The content needs to load fast and the requests won't be complex.                             |
| HTTP Server | h2o @ Ubuntu 24.04.4 LTS    | I heard about h2o being an extremely lightweight and fast server, so i wanted to test it out. |

### Milestones
- [x] Create a web server and home-host @ https://dashou.dev
- [x] Setup a GitHub action to pull the code to the server on each main branch push.
- [x] Design the database schema
- [ ] Sketch an idea of the different pages of the website
- [x] Get the SQLite server working
- [ ] Get the ExpressJS back-end working
- [ ] Construct the different static web pages
- [x] Make the dynamic content load in the static web pages
