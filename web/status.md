---
layout: default
title: Status
---

# Status

{% assign hostname = site.data.config %}
Hostname: {{ hostname }}

---

{% for item in hostname %}
{{ item }}
{% endfor %}

