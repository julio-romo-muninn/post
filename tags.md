---
layout: page
title: Tags
permalink: /tags/
description: "Explora todos los posts por etiquetas."
---

<div class="terminal-window">
  <div class="terminal-header">
    <span class="terminal-dot red"></span>
    <span class="terminal-dot yellow"></span>
    <span class="terminal-dot green"></span>
    <span class="terminal-title">~/tags</span>
  </div>
  <div class="terminal-body">
    <div class="terminal-line">
      <span class="prompt">$</span> ls -la ./tags/ | sort -k5 -rn
    </div>
    <div class="terminal-output">
      <div class="ls-header">total {{ site.tags.size }} etiquetas</div>
      {% assign tags = site.tags | sort %}
      {% for tag in tags %}
      <a href="{{ site.baseurl }}/tags/{{ tag[0] | slugify }}/" class="ls-row">
        <span class="ls-perms">-rw-r--r--</span>
        <span class="ls-count">{{ tag[1].size }}</span>
        <span class="ls-user">tpx</span>
        <span class="ls-group">tags</span>
        <span class="ls-size">{{ tag[1].size | times: 2 }}K</span>
        <span class="ls-date">{{ site.time | date: "%b %d %H:%M" }}</span>
        <span class="ls-name"><span class="folder-icon">🏷️</span> #{{ tag[0] }}</span>
      </a>
      {% endfor %}
    </div>
    <div class="terminal-line">
      <span class="prompt">$</span> <span class="cursor blink">_</span>
    </div>
  </div>
</div>

{% if site.tags.size == 0 %}
<div class="terminal-line">
  <span class="prompt">$</span> echo "No hay tags disponibles todavía..."
</div>
{% endif %}
