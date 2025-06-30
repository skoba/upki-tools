# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails web application for managing SSL certificates within the Japanese University PKI (UPKI) system. The application handles certificate lifecycle management including CSR generation, issuance, renewal, and revocation, developed by the Medical Open Source Software Consortium.

## Development Commands

### Setup
```bash
# Install all dependencies and setup database
bin/setup

# Manual dependency installation
bundle install
npm install
```

### Database
```bash
bin/rails db:prepare     # Setup database
bin/rails db:migrate     # Run migrations
bin/rails db:reset       # Reset database
```

### Development Server
```bash
bin/rails server         # Start Rails server
guard start              # Automated development workflow (tests, linting, server, livereload)
```

### Testing
```bash
bin/rspec                # Run all tests
bin/rspec spec/models/   # Run specific test directory
guard start              # Continuous testing on file changes
```

### Code Quality
```bash
bundle exec rubocop      # Run linting
bundle exec rubocop -a   # Auto-fix linting issues
```

### Assets
```bash
bin/webpack              # Compile assets
bin/rails assets:precompile  # Precompile for production
```

## Architecture

### Core Models
- **Certificate**: Main entity managing SSL certificate lifecycle, CSR generation, and file operations
- **Domain**: Represents domain names associated with certificates  
- **Person**: Certificate administrators/operators
- **Relationship**: Person → Domain → Certificates (one-to-many)

### Key Components
- **Certificate Generation**: Uses OpenSSL for RSA 2048-bit key and CSR creation
- **TSV Integration**: Handles tab-separated data format for UPKI system communication
- **Batch Operations**: Mass certificate management (revocation, updates)
- **File Management**: ZIP archive creation for certificate delivery
- **Svelte Components**: Reactive frontend components in `app/javascript/`

### Technology Stack
- **Backend**: Ruby 3.4.4, Rails 8.0.2, SQLite3 2.7, Puma 6.0
- **Frontend**: Importmap-rails, Turbo-rails, Stimulus-rails, Bootstrap 5.3, jQuery
- **Testing**: RSpec with FactoryBot, Guard for automation
- **Security**: RSA 2048-bit keys, SHA-256 signatures, CSRF protection

### Configuration
- **profile.yml**: PKI-specific DN configuration for certificate generation
- **config/importmap.rb**: JavaScript module imports configuration
- **Japanese localization**: Primary language with English fallback
- **Tokyo timezone**: Configured for JST

### Development Workflow
The application uses Guard for automated development workflow. Run `guard start` to enable:
- Automatic RSpec test execution on file changes
- RuboCop linting on Ruby file modifications
- Rails server restart on configuration changes
- Browser LiveReload for rapid development

### Rails 8 Modern Frontend
- **Importmap-rails**: Manages JavaScript imports without bundling
- **Turbo-rails**: Provides SPA-like navigation with server-side rendering
- **Stimulus-rails**: Lightweight JavaScript framework for progressive enhancement
- **Bootstrap 5.3**: Modern CSS framework for responsive design

### File Structure Notes
- Certificate operations generate temporary files that are automatically cleaned up
- Private keys and CSRs are created in memory and delivered via secure ZIP downloads
- Active Storage handles file attachments for certificate-related documents
- All cryptographic operations use Ruby's OpenSSL library with secure defaults
- JavaScript controllers in `app/javascript/controllers/` for interactive features