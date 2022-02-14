---
layout: default
title: Status
---

# Status

{% assign hostname = site.config.hostname %}
{{ hostname }}
{% for item in hostname %}
{{ item }}
{% endfor %}