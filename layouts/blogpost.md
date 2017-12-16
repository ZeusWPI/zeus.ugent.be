<article class="blogpost column is-offset-2 is-8" markdown="1">

<% if item[:toc] %>
<div id="table-of-contents" class="menu column is-4" markdown="1">
  <p class="menu-label">
    Inhoudstabel
  </p>
<% if item[:toc].is_a? Hash %>
* x
{:toc .toc-depth-<%= item[:toc][:depth] %>}
<% else %>
* x
{:toc}
<% end %>
</div>
<% end %>

<div class="content is-medium-responsive" markdown="1">
<%= yield %>
</div>
</article>
