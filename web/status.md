---
layout: default
title: Status
---

# Status

This page is hosted on node {{ site.hostname }}

---

{% for item in hostname %}
{{ item.hostname }}
{% endfor %}

