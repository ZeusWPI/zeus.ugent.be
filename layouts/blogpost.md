<article class="column is-offset-2 is-8" markdown="1">
<div class="content is-medium" markdown="1">
<%= yield %>
</div>
</article>

<% if item[:toc] %>
<div class="menu column" markdown="1">
  <p class="menu-label">
    Table of Contents
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
