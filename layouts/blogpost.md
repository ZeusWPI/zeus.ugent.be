<% if item[:toc] %>
<aside class="menu is-pulled-right" markdown="1">
  <p class="menu-label">
    Table of Contents
  </p>
* x
{:toc .toc-depth-<%= item[:toc][:depth] %>}
</aside>
<% end %>

<%= yield %>
