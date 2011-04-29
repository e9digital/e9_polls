require 'e9_polls'

# the fallback HTML layout for polls views (typically JS renders)
E9Polls.fallback_html_layout = 'application'

# the name of the cookie which tracks client votes
E9Polls.cookie_name = 'e9_polls'

# the number of css classes for the "bars" in the results view that
# represent the answer count, defaults to 5, cycling (.pab-1, .pab-2, etc.)
E9Polls.bar_css_class_count = 5
