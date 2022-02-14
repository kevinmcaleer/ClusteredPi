---
layout: default
title: Status
---

# Status

{% assign hostname = site.data.config %}
Hostname: {{ hostname }}

hostname 2: {{ site.hostname }}
---

{% for item in hostname %}
{{ item.hostname }}
{% endfor %}

