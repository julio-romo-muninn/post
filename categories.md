---
layout: page
title: Categorías
permalink: /categories/
description: "Explora todos los posts organizados por categorías."
---

<div class="terminal-window">
  <div class="terminal-header">
    <span class="terminal-dot red"></span>
    <span class="terminal-dot yellow"></span>
    <span class="terminal-dot green"></span>
    <span class="terminal-title">~/categorias</span>
  </div>
  <div class="terminal-body">
    <div class="terminal-line">
      <span class="prompt">$</span> ls -lh ./categorias/
    </div>
    <div class="terminal-output">
      <div class="ls-header">total {{ site.categories.size }} directorios</div>
      {% for category in site.categories %}
      <a href="{{ site.baseurl }}/categories/{{ category[0] | slugify }}/" class="ls-row">
        <span class="ls-perms">drwxr-xr-x</span>
        <span class="ls-count">{{ category[1].size }}</span>
        <span class="ls-user">tpx</span>
        <span class="ls-group">posts</span>
        <span class="ls-size">{{ category[1].size | times: 4 }}K</span>
        <span class="ls-date">{{ site.time | date: "%b %d %H:%M" }}</span>
        <span class="ls-name"><span class="folder-icon">📁</span> {{ category[0] }}/</span>
      </a>
      {% endfor %}
    </div>
    <div class="terminal-line">
      <span class="prompt">$</span> <span class="cursor blink">_</span>
    </div>
  </div>
</div>

{% if site.categories.size == 0 %}
<div class="terminal-line">
  <span class="prompt">$</span> echo "No hay categorías disponibles todavía..."
</div>
{% endif %}
