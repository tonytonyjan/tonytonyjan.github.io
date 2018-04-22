---
title: "List Published or Unpublished Posts in Octopress"
date: 2012-05-02 13:36 +0800

tags: [Octopress, Plugin]
---

## What's the Problem?

We may leave some draft posts in `_posts` directory, but it comes a problem when we are going to find whether the post is published or not by reading throuh filenames in the future.

To solve this, I created this rake task. It will list all posts each line, and prepend an asterisk if it's published. Just append it in your `Rakefile` to make it works.

### Usage

    rake list_posts
    rake list_posts[pub|unpub]

{% gist 2574782 %}