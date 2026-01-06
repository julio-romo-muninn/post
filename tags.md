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
      <a href="#{{ tag[0] | slugify }}" class="ls-row tag-link" data-tag="{{ tag[0] | slugify }}">
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
  </div>
</div>

{% assign tags = site.tags | sort %}
{% for tag in tags %}
<section id="{{ tag[0] | slugify }}" class="tag-section">
  <div class="section-header">
    <h2 class="section-title">
      <span class="prompt">$</span> grep -l "#{{ tag[0] }}" ./posts/*
    </h2>
    <span class="post-count">{{ tag[1].size }} posts</span>
  </div>
  
  <div class="posts-grid">
    {% for post in tag[1] %}
    <article class="post-card">
      <div class="post-meta">
        <time datetime="{{ post.date | date_to_xmlschema }}">
          {{ post.date | date: "%d/%m/%Y" }}
        </time>
      </div>
      <h3 class="post-title">
        <a href="{{ post.url | relative_url }}">
          <span class="prompt">></span> {{ post.title }}
        </a>
      </h3>
      <p class="post-excerpt">{{ post.excerpt | strip_html | truncate: 120 }}</p>
    </article>
    {% endfor %}
  </div>
</section>
{% endfor %}

{% if site.tags.size == 0 %}
<div class="terminal-line">
  <span class="prompt">$</span> echo "No hay tags disponibles todavía..."
</div>
{% endif %}
