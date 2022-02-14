---
layout: default
title: Status
---

# Status

{% assign hostname = site.hostname %}
{{ hostname }}
{% for item in hostname %}
{{ item }}
{% endfor %}