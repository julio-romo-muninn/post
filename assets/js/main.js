// ==============================================
// MAIN JAVASCRIPT - tpx BLOG
// ==============================================

document.addEventListener('DOMContentLoaded', function() {
  // ==============================================
  // SEARCH FUNCTIONALITY
  // ==============================================
  const searchInput = document.getElementById('search-input');
  const searchResults = document.getElementById('search-results');
  let searchData = [];
  let searchTimeout = null;

  // Load search data
  if (searchInput) {
    fetch('/search.json')
      .then(response => response.json())
      .then(data => {
        searchData = data;
      })
      .catch(error => console.error('Error loading search data:', error));

    searchInput.addEventListener('input', function() {
      clearTimeout(searchTimeout);
      const query = this.value.trim().toLowerCase();
      
      // Debounce search
      searchTimeout = setTimeout(function() {
        if (query.length < 2) {
          searchResults.innerHTML = '';
          searchResults.classList.remove('active');
          return;
        }
        
        performSearch(query);
      }, 200);
    });

    // Close results on click outside
    document.addEventListener('click', function(e) {
      if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
        searchResults.classList.remove('active');
      }
    });

    // Keyboard navigation
    searchInput.addEventListener('keydown', function(e) {
      const items = searchResults.querySelectorAll('.search-result-item');
      const active = searchResults.querySelector('.search-result-item.active');
      
      if (e.key === 'ArrowDown') {
        e.preventDefault();
        if (!active && items.length > 0) {
          items[0].classList.add('active');
        } else if (active && active.nextElementSibling) {
          active.classList.remove('active');
          active.nextElementSibling.classList.add('active');
        }
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        if (active && active.previousElementSibling) {
          active.classList.remove('active');
          active.previousElementSibling.classList.add('active');
        }
      } else if (e.key === 'Enter') {
        e.preventDefault();
        const activeItem = searchResults.querySelector('.search-result-item.active');
        if (activeItem) {
          window.location.href = activeItem.href;
        }
      } else if (e.key === 'Escape') {
        searchResults.classList.remove('active');
        searchInput.blur();
      }
    });
  }

  function performSearch(query) {
    const results = searchData.filter(function(post) {
      const titleMatch = post.title.toLowerCase().includes(query);
      const excerptMatch = post.excerpt.toLowerCase().includes(query);
      const contentMatch = post.content.toLowerCase().includes(query);
      const categoryMatch = post.categories.some(cat => cat.toLowerCase().includes(query));
      const tagMatch = post.tags.some(tag => tag.toLowerCase().includes(query));
      
      return titleMatch || excerptMatch || contentMatch || categoryMatch || tagMatch;
    });

    displayResults(results, query);
  }

  function displayResults(results, query) {
    if (results.length === 0) {
      searchResults.innerHTML = `
        <div class="search-no-results">
          <span class="prompt">$</span> grep: no matches found for "${escapeHtml(query)}"
        </div>
      `;
      searchResults.classList.add('active');
      return;
    }

    const html = results.slice(0, 10).map(function(post) {
      const highlightedTitle = highlightMatch(post.title, query);
      const highlightedExcerpt = highlightMatch(post.excerpt.substring(0, 100), query);
      
      return `
        <a href="${post.url}" class="search-result-item">
          <div class="search-result-title">
            <span class="prompt">></span> ${highlightedTitle}
          </div>
          <div class="search-result-meta">
            <span class="search-result-date">${post.date}</span>
            ${post.categories.length > 0 ? `<span class="search-result-category">${post.categories[0]}</span>` : ''}
          </div>
          <div class="search-result-excerpt">${highlightedExcerpt}...</div>
        </a>
      `;
    }).join('');

    searchResults.innerHTML = `
      <div class="search-results-header">
        <span class="prompt">$</span> ${results.length} resultado${results.length !== 1 ? 's' : ''} encontrado${results.length !== 1 ? 's' : ''}
      </div>
      ${html}
    `;
    searchResults.classList.add('active');
  }

  function highlightMatch(text, query) {
    if (!text) return '';
    const regex = new RegExp('(' + escapeRegex(query) + ')', 'gi');
    return escapeHtml(text).replace(regex, '<mark>$1</mark>');
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function escapeRegex(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  // ==============================================
  // NEWSLETTER FORM HANDLING
  // ==============================================
  const newsletterForm = document.getElementById('newsletter-form');
  const newsletterMessage = document.getElementById('newsletter-message');

  if (newsletterForm) {
    newsletterForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const emailInput = document.getElementById('newsletter-email');
      const submitBtn = newsletterForm.querySelector('.btn-subscribe');
      const btnText = submitBtn.querySelector('.btn-text');
      const btnLoading = submitBtn.querySelector('.btn-loading');
      
      // Validar email
      const email = emailInput.value.trim();
      if (!isValidEmail(email)) {
        showMessage('error', '$ error: formato de email inválido');
        return;
      }
      
      // Mostrar loading
      btnText.hidden = true;
      btnLoading.hidden = false;
      submitBtn.disabled = true;
      
      // Enviar formulario
      const formData = new FormData(newsletterForm);
      
      fetch(newsletterForm.action, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(function(response) {
        if (response.ok) {
          showMessage('success', '$ echo "¡Suscripción exitosa! Bienvenido a tpx 🎉"');
          emailInput.value = '';
        } else {
          throw new Error('Error en la suscripción');
        }
      })
      .catch(function(error) {
        showMessage('error', '$ error: No se pudo completar la suscripción. Intenta de nuevo.');
        console.error('Newsletter error:', error);
      })
      .finally(function() {
        btnText.hidden = false;
        btnLoading.hidden = true;
        submitBtn.disabled = false;
      });
    });
  }

  function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  }

  function showMessage(type, message) {
    if (!newsletterMessage) return;
    
    newsletterMessage.textContent = message;
    newsletterMessage.className = 'newsletter-message ' + type;
    newsletterMessage.hidden = false;
    
    // Auto-hide after 5 seconds
    setTimeout(function() {
      newsletterMessage.hidden = true;
    }, 5000);
  }

  // Smooth scroll to newsletter from footer link
  document.querySelectorAll('a[href="#newsletter-form"]').forEach(function(link) {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const target = document.getElementById('newsletter-form');
      if (target) {
        target.scrollIntoView({ behavior: 'smooth', block: 'center' });
        document.getElementById('newsletter-email').focus();
      }
    });
  });

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
  
  console.log('%c[tpx BLOG]%c Welcome, hacker! 🖥️', 
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
