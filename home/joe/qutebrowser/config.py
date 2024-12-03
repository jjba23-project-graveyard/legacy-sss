# Do not load config made via UI - purely declarative
config.load_autoconfig(False)

# Load Emacs-like key bindings
config.source('bindings.py')

# Use best fuzzy match
config.set('completion.use_best_match', True)

