---
layout: default
title: Status
---

{% assign hostname = site.data.config %}
{% for item in hostname %}
{{ item }}
{% endfor %}