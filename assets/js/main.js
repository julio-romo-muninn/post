// ==============================================
// MAIN JAVASCRIPT - TPX BLOG
// ==============================================

document.addEventListener('DOMContentLoaded', function() {
  // Mobile Navigation Toggle
  const navToggle = document.querySelector('.nav-toggle');
  const navMenu = document.querySelector('.nav-menu');
  const navOverlay = document.querySelector('.nav-overlay');
  
  function closeMenu() {
    navMenu.classList.remove('active');
    navToggle.setAttribute('aria-expanded', 'false');
    if (navOverlay) navOverlay.classList.remove('active');
    document.body.style.overflow = '';
  }
  
  function openMenu() {
    navMenu.classList.add('active');
    navToggle.setAttribute('aria-expanded', 'true');
    if (navOverlay) navOverlay.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
  
  if (navToggle && navMenu) {
    navToggle.addEventListener('click', function() {
      const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
      if (isExpanded) {
        closeMenu();
      } else {
        openMenu();
      }
    });
    
    // Close menu when clicking overlay
    if (navOverlay) {
      navOverlay.addEventListener('click', closeMenu);
    }
    
    // Close menu when clicking on a link
    navMenu.querySelectorAll('.nav-link').forEach(function(link) {
      link.addEventListener('click', closeMenu);
    });
  }
  
  // Theme Toggle
  const themeToggle = document.querySelector('.theme-toggle');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
  
  function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }
  
  function getTheme() {
    return localStorage.getItem('theme') || (prefersDark.matches ? 'dark' : 'light');
  }
  
  // Initialize theme
  setTheme(getTheme());
  
  if (themeToggle) {
    themeToggle.addEventListener('click', function() {
      const currentTheme = getTheme();
      setTheme(currentTheme === 'dark' ? 'light' : 'dark');
    });
  }
  
  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
    anchor.addEventListener('click', function(e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
  
  // Add active class to TOC items on scroll
  const tocLinks = document.querySelectorAll('.toc-link');
  const headings = document.querySelectorAll('.post-content h2, .post-content h3');
  
  if (tocLinks.length > 0 && headings.length > 0) {
    const observerOptions = {
      rootMargin: '-80px 0px -80% 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          tocLinks.forEach(function(link) {
            link.classList.remove('active');
            if (link.getAttribute('href') === '#' + entry.target.id) {
              link.classList.add('active');
            }
          });
        }
      });
    }, observerOptions);
    
    headings.forEach(function(heading) {
      observer.observe(heading);
    });
  }
  
  // Add IDs to headings that don't have them
  document.querySelectorAll('.post-content h2, .post-content h3, .post-content h4').forEach(function(heading, index) {
    if (!heading.id) {
      heading.id = heading.textContent.toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/(^-|-$)/g, '') || 'heading-' + index;
    }
  });
  
  // Lazy load images
  if ('loading' in HTMLImageElement.prototype) {
    document.querySelectorAll('img[data-src]').forEach(function(img) {
      img.src = img.dataset.src;
    });
  } else {
    // Fallback for browsers that don't support lazy loading
    const lazyImages = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          imageObserver.unobserve(img);
        }
      });
    });
    
    lazyImages.forEach(function(img) {
      imageObserver.observe(img);
    });
  }
  
  // Reading progress indicator
  const progressBar = document.querySelector('.reading-progress');
  if (progressBar) {
    window.addEventListener('scroll', function() {
      const scrollTop = window.scrollY;
      const docHeight = document.documentElement.scrollHeight - window.innerHeight;
      const progress = (scrollTop / docHeight) * 100;
      progressBar.style.width = progress + '%';
    });
  }
  
  // Terminal typing effect
  const typingElements = document.querySelectorAll('.typing-animate');
  typingElements.forEach(function(element) {
    const text = element.textContent;
    element.textContent = '';
    let i = 0;
    
    function type() {
      if (i < text.length) {
        element.textContent += text.charAt(i);
        i++;
        setTimeout(type, 50);
      }
    }
    
    type();
  });

  // ==============================================
  // SCROLL REVEAL ANIMATIONS (Subtle)
  // ==============================================
  const animatedElements = document.querySelectorAll('[data-animate]');
  
  if (animatedElements.length > 0) {
    const revealObserver = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
        }
      });
    }, {
      threshold: 0.1,
      rootMargin: '0px 0px -30px 0px'
    });
    
    animatedElements.forEach(function(el) {
      revealObserver.observe(el);
    });
  }
  
  console.log('%c[TPX BLOG]%c Welcome, hacker! 🖥️', 
    'color: #ffd607; font-weight: bold; font-size: 14px;',
    'color: #e6edf3; font-size: 12px;'
  );
});

// External links open in new tab
document.querySelectorAll('a[href^="http"]').forEach(function(link) {
  if (!link.href.includes(window.location.hostname)) {
    link.setAttribute('target', '_blank');
    link.setAttribute('rel', 'noopener noreferrer');
  }
});
