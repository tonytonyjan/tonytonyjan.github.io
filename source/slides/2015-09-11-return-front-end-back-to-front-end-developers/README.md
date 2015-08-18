Gulp on Rails: Return Front-end back to Front-end Developers (還給前端工程師一個天空)
=====================================================================================

## Summary

Rails sprockets is dated. It was an awesome tool in years since its inception. Although it's easy to use, when it starts having bugs (we know it had), front-end developers are helpless in what is supposed to be their own ecosystem, because they don't know Ruby. Why should a front-end developers knows how to use Sprockets/Ruby instead of using their tools like gulp, grunt, browserify, webpack, etc, that belongs to JS ecosystem?

Gulp, a modern approach to asset pipeline has become more popular and actively maintained by JS community. In this session, I'll share how and why I integrate Gulp and Rails.

## Outline

- How sprockets works?
- What problems does sprockets solve?
  - coffeescript, sass, assets concat, digest, etc.
- Why sprockets is dated.
  - Rails does too much.
  - Font-end tools has made a great evolution today.
  - Don't magnage your assets via gems.
- Solutions
  - https://rails-assets.org/
  - Rails API + Nodejs
  - Grape + Nodejs
  - gulp-rails-pipeline