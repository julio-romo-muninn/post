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
      <a href="#{{ category[0] | slugify }}" class="ls-row category-link" data-category="{{ category[0] | slugify }}">
        <span class="ls-perms">drwxr-xr-x</span>
        <span class="ls-count">{{ category[1].size }}</span>
        <span class="ls-user">tpx</span>
        <span class="ls-group">posts</span>
        <span class="ls-size">{{ category[1].size | times: 4 }}K</span>
        <span class="ls-date">{{ site.time | date: "%b %d %H:%M" }}</span>
        <span class="ls-name"><i class="fas fa-folder"></i> {{ category[0] }}/</span>
      </a>
      {% endfor %}
    </div>
  </div>
</div>

{% for category in site.categories %}
<section id="{{ category[0] | slugify }}" class="category-section">
  <div class="section-header">
    <h2 class="section-title">
      <span class="prompt">$</span> cat ./{{ category[0] | slugify }}/*
    </h2>
    <span class="post-count">{{ category[1].size }} posts</span>
  </div>
  
  <div class="archive-content">
    <ul class="archive-list">
      {% for post in category[1] %}
      <li class="archive-item">
        <time datetime="{{ post.date | date_to_xmlschema }}">
          {{ post.date | date: "%d/%m" }}
        </time>
        <a href="{{ post.url | relative_url }}">
          <span class="prompt">></span> {{ post.title }}
        </a>
        {% if post.tags.size > 0 %}
        <span class="archive-category">{{ post.tags | first }}</span>
        {% endif %}
      </li>
      {% endfor %}
    </ul>
  </div>
</section>
{% endfor %}

{% if site.categories.size == 0 %}
<div class="terminal-line">
  <span class="prompt">$</span> echo "No hay categorías disponibles todavía..."
</div>
{% endif %}
