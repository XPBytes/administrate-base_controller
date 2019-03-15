# Administrate::BaseController

[![Build Status: master](https://travis-ci.com/XPBytes/administrate-base_controller.svg)](https://travis-ci.com/XPBytes/administrate-base_controller)
[![Gem Version](https://badge.fury.io/rb/administrate-base_controller.svg)](https://badge.fury.io/rb/administrate-base_controller)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

Extends the `ApplicationController` in [Administrate](https://github.com/thoughtbot/administrate)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'administrate-base_controller'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install administrate-base_controller

## Usage

When you require this gem, the base controller functionality will be added to the `administrate/application_controller`.

You get the following _protected_ methods for free, which you may override:

| method | short | description |
|--------|-------|-------------|
| `search_term` | `params[:search]` |  Allows you to assign custom behaviour for the `search_term` on `index` pages |
| `index_scoped_resource` | `scoped_resource` | Allows you to overwrite which resources are shown on `index` or passed to search |
| `index_resources` | `Administrate::Search` | Allows you to turn off search on `index`, by overwriting this |
| `index_page` | `Administrate::Page::Collection` | Allows you to overwrite the `index` page |
| `show_page` | `Administrate::Page::Show` | Allows you to overwrite the `show` page |
| `new_page` | `Administrate::Page::Form` | Allows you to overwrite the `new` page |
| `edit_page` | `new_page` | Allows you to overwrite the `edit` page |
| `edit_page` | `new_page` | Allows you to overwrite the `edit` page |
| `authorize_resource` | `show_action?(action_name.to_sym, resource)` | Allows you to change how resources are authorized |
| `resource_params` | Calls `read_param(k, v)` for each instead of `transform_values` | Allows you to change how params are read |
| `read_param` | Calls `read_param_value` if applicable | Allows you to change how a param is read based on its key |

```ruby
module Admin
  class ApplicationController < Administrate::ApplicationController
    # everything is available now
  end
end
```

### Integrate with CanCan(Can)

This automatically hides links if the `current_admin_user` does not have the ability to `action` the `resource`.

```ruby
module Admin
  class ApplicationController < Administrate::ApplicationController
    def current_ability
      @_current_ability ||= Ability.new(current_admin_user)
     end
    
    def show_action?(action, resource)
      current_ability.can?(action.to_sym, resource)
    end
  end
end
```

Additionally you can correctly hide resources the `current_ability` can not `action`:

```ruby
module Admin
  class ApplicationController < Administrate::ApplicationController
    
    # ...
     
    def scoped_resource
      super.accessible_by(current_ability, action_name.to_sym)
    end
  end 
end
```

### Integrate with FriendlyId

This works without this gem, but this gem allows you to changed `scoped_resource` and `index_scoped_resource` easily.

```ruby
module Admin
  class BookController < ::Admin::ApplicationController
    def find_resource(param)
      scoped_resource.friendly.find(param)  
    end 
  end
end
```

### Only show subset of resources on index

You might want to scope the `index` to a current view (like stored in `Admin::Current.view`), but not `404` if the
resource is accessed directly:

```ruby
module Admin
  class BookController < ::Admin::ApplicationController
    def index_scoped_resource
      super.where(author: Current.author)
    end 
  end
end
```

This only shows the books with the `Current.author`, but if you access `/book/uuid`, it will find the book even if its
by a different author.

### Preset attributes on a new resource

You might want to preset certain attributes when creating a new resource. You can do so by overriding `new_resource`.

```ruby
module Admin
  class BookController < ::Admin::ApplicationController
    def new_resource
      resource_class.new(author: Current.author)
    end 
  end
end
```

### Deserialize attributes (e.g. JSON field)

If you want to deserialize an attribute's value before it's assigned to the resource, for example from a custom JSON
field, which contents have been serialized, you can overwrite `read_param`:

```ruby
module Admin
  class BookController < ::Admin::ApplicationController
    JSON_FIELDS = %w[options content].freeze
    
    def read_param(key, value)
      return Oj.load(value) if JSON_FIELDS.include?(String(key))
      super(key, value)
    end
  end 
end
```

Alternatively you can use the [`administrate-serialized_fields`](https://github.com/XPBytes/administrate-serialized_fields) gem.

## Related

- [`Administrate`](https://github.com/thoughtbot/administrate): A Rails engine that helps you put together a super-flexible admin dashboard.
<!-- - [`Administrate::BaseController`](https://github.com/XPBytes/administrate-base_controller): A set of application controller improvements. -->

### Concerns

- [`Administrate::DefaultOrder`](https://github.com/XPBytes/administrate-default_order): Sets the default order for a resource in a administrate controller.
- [`Administrate::SerializedFields`](https://github.com/XPBytes/administrate-serialized_fields): Automatically deserialize administrate fields on form submit.

### Fields

- [`Administrate::Field::Code`](https://github.com/XPBytes/administrate-field-code): A `text` field that shows code.
- [`Administrate::Field::Hyperlink`](https://github.com/XPBytes/administrate-field-hyperlink): A `string` field that is shows a hyperlink.
- [`Adminisrtate::Field::JsonEditor`](https://github.com/XPBytes/administrate-field-json_editor): A `text` field that shows a [JSON editor](https://github.com/josdejong/jsoneditor).
- [`Administrate::Field::ScopedBelongsTo`](https://github.com/XPBytes/administrate-field-scoped_belongs_to): A `belongs_to` field that yields itself to the scope `lambda`.
- [`Administrate::Field::ScopedHasMany`](https://github.com/XPBytes/administrate-field-scoped_has_many): A `has_many` field that yields itself to the scope `lambda`.
- [`Administrate::Field::TimeAgo`](https://github.com/XPBytes/administrate-field-time_ago): A `date_time` field that shows its data as `time_ago` since.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [XPBytes/administrate-base_controller](https://github.com/XPBytes/administrate-base_controller).
