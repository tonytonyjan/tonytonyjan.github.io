---
title: "在 Octopress 加上近期回覆"
date: 2012-02-12 19:14 +0800
tags: [Octopress, Disqus]

---

[disqus]: http://disqus.com

octopress 內建的回覆外掛是 [disqus]。但卻沒有提供在 asides 顯示近期回應的功能，加上我在網路上查不太到別人的寫法，於是我就自己寫了一個，也許對一些人有幫助：

```html
<!-- source\_includes\custom\asides\recent_comments.html -->
{% if site.disqus_short_name and page.comments != false %}
<section>
  <h1>近期回覆</h1>
  <script type="text/javascript">
    function recent_comments(obj){
      if(obj.response.length){
        resault = '<ul>';
        obj.response.forEach(function(response){
          resault += '<li>';
          resault += '[]('+response.author.profileUrl+'"><img src="'+response.author.avatar.permalink+'" width=32 height=32 style="float: left; margin-right: 5px;)';
          resault += '['+response.author.name+']('+response.author.profileUrl+')：';
          resault += ''+response.message+'

'
          resault += '['+response.thread.title+']('+response.thread.link+')

'
          resault += 'at ['+response.createdAt+']('+response.url+')'
          resault += '</li>';
        });
        resault += '</ul>';
        document.write(resault);
      }else{
        document.write("目前沒有回覆");
      }
    };
  </script>
  <script type="text/javascript" src="http://disqus.com/api/3.0/forums/listPosts.jsonp?forum={{ site.disqus_short_name }}&api_key=IVQOSOjZknRNZi3rYa3gxFA5CCLjuGP9ojHi3TSeUenFl2mckhh3gl9k9NqGDetu&related=thread&callback=recent_comments"></script>
</section>
{% endif %}
```

備註：需要用到 [disqus] 提供的 [API](http://disqus.com/api)。
