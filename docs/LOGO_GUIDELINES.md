<div align="center">
  <img src="../assets/doc-banner.png" alt="Doc Banner">
</div>

# Logo Usage Guidelines

## Overview
This document provides comprehensive guidelines for using the Agentic Haxe project logos across documentation and user interface components.

## Available Logo Assets

### Primary Logo
- **File**: `assets/logo.png`
- **Usage**: Main project logo for all documentation and primary UI headers
- **Dimensions**: 200x200px (recommended display size)
- **Format**: PNG with transparency

### Alternative Logos
- **Files**: `assets/tb_3.png`, `assets/tb_4.png`, `assets/tb_5.png`
- **Usage**: Alternative branding options for UI components
- **Format**: PNG with transparency

## Documentation Guidelines

### Markdown Files
All markdown files should include the logo at the top using this standard format:

```markdown
<div align="center">
  <img src="assets/logo.png" alt="Agentic Haxe Logo" width="200" height="200">
</div>
```

### Path Adjustments
Adjust the path based on file location:
- Root level files: `assets/logo.png`
- PoC documents: `../assets/logo.png`
- Implementation READMEs: `../../../assets/logo.png`

### Size Recommendations
- **Main README files**: 200x200px
- **PoC documents**: 200x200px
- **Implementation docs**: 150x150px
- **Sub-documentation**: 120x120px

## UI Component Guidelines

### HTML Implementation
```html
<!-- Header with Logo -->
<header class="app-header">
    <div class="logo-container">
        <img src="../../../assets/logo.png" alt="Agentic Haxe Logo" class="app-logo">
        <h1 class="app-title">Application Name</h1>
    </div>
</header>
```

### CSS Styling
```css
.app-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 1rem 2rem;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.app-logo {
    width: 50px;
    height: 50px;
    border-radius: 8px;
}

.app-title {
    margin: 0;
    font-size: 1.5rem;
    font-weight: 600;
}
```

### Responsive Design
```css
@media (max-width: 768px) {
    .app-header {
        padding: 0.75rem 1rem;
    }
    
    .app-logo {
        width: 40px;
        height: 40px;
    }
    
    .app-title {
        font-size: 1.25rem;
    }
}
```

## Platform-Specific Guidelines

### Frontend JavaScript
- Use `assets/logo.png` for main headers
- Alternative logos (`tb_3.png`, `tb_4.png`, `tb_5.png`) for secondary UI elements
- Ensure proper path resolution based on build output structure

### Multi-Target Implementations
- Maintain consistent logo placement across all platform targets
- Adjust paths relative to each platform's build output
- Ensure logos are accessible in all deployment environments

## Brand Consistency Rules

### DO
- Always use the official logo files from the `assets/` directory
- Maintain aspect ratio when resizing
- Use consistent alt text: "Agentic Haxe Logo"
- Center-align logos in documentation headers
- Use appropriate sizing for context

### DON'T
- Modify logo colors or design
- Stretch or distort logo proportions
- Use low-resolution versions
- Place logos without proper spacing
- Use generic alt text

## File Structure Requirements

### Assets Organization
```
assets/
├── logo.png          # Primary logo
├── tb.png           # Alternative logo 1
├── tb_3.png         # Alternative logo 2
├── tb_4.png         # Alternative logo 3
└── tb_5.png         # Alternative logo 4
```

### Implementation Checklist
- [ ] Logo added to main README.md
- [ ] Logo added to README-dk.md
- [ ] Logos added to all PoC documents (01-08)
- [ ] Logos added to all implementation READMEs
- [ ] Logos added to architecture documents
- [ ] Logos implemented in UI components
- [ ] CSS styling for logos implemented
- [ ] Responsive design for logos implemented
- [ ] Path resolution verified for all contexts

## Quality Assurance

### Testing Checklist
- Verify logo displays correctly in all markdown files
- Test logo rendering in different browsers
- Confirm responsive behavior on mobile devices
- Validate path resolution in build outputs
- Check logo accessibility (alt text, contrast)

### Maintenance
- Review logo implementations quarterly
- Update paths when restructuring project
- Ensure new documentation includes logos
- Maintain consistency across all platforms

## Contact
For questions about logo usage or brand guidelines, refer to the project maintainers or create an issue in the project repository.

<div align="center">
  <img src="../assets/footer.png" alt="Footer">
</div>