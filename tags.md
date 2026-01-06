---
layout: page
title: Tags
permalink: /tags/
description: "Explora todos los posts por etiquetas."
---

<div class="tags-cloud">
{% assign tags = site.tags | sort %}
{% for tag in tags %}
  <a href="{{ site.baseurl }}/tags/{{ tag[0] | slugify }}/" class="tag-cloud-item">
    #{{ tag[0] }} <span class="count">({{ tag[1].size }})</span>
  </a>
{% endfor %}
</div>

{% if site.tags.size == 0 %}
<p class="empty-message">
  <span class="prompt">$</span> echo "No hay tags disponibles todavía..."
</p>
{% endif %}
