# Changelog

## 0.7.0

- Update pagination params

## 0.6.0

- Fixes transforming polymorphic relations through `read_param`
- Update all dependencies

## 0.5.0

- Update collection call in `index` and `administrate` dependency
- Update all dependencies

## 0.4.1

- 🚨 Update nokogiri: 1.10.2 → 1.10.3
- Update all of rails to version 5.2.3

## 0.4.0

- Extract all methods into a module `BaseController`
- Remove default `after_initialize` evaluation. You may require `administrate/base_controller/engine` instead
- Add some annotations to some of the methods

## 0.3.0

- Add json rendering for index and show paths
- Add `render_index_json(resources)` to easily override json responses on the index route
- Add `render_index_any(resources, format:)` to easily override non-json responses on the index route
- Add `render_show_json(resource)` to easily override json responses on the show route
- Add `render_show_any(resource, format:)` to easily override non-json responses on the show route

## 0.2.0

Load on after_initialize hook

## 0.1.0

:baby: Initial version
