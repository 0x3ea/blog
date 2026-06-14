---
date: '{{ .Date }}'
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
{{- $dir := strings.TrimSuffix "/" .File.Dir }}
{{- $category := path.Base $dir }}
categories:
  - {{ $category }}
tags:
---
