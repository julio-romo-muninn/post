---
layout: page
title: Categorías
permalink: /categories/
description: "Explora todos los posts organizados por categorías."
---

<div class="categories-grid">
{% for category in site.categories %}
  <a href="{{ site.baseurl }}/categories/{{ category[0] | slugify }}/" class="category-card">
    <h3 class="category-name">{{ category[0] }}</h3>
    <span class="category-count">{{ category[1].size }} posts</span>
  </a>
{% endfor %}
</div>

{% if site.categories.size == 0 %}
<p class="empty-message">
  <span class="prompt">$</span> echo "No hay categorías disponibles todavía..."
</p>
{% endif %}
