document.addEventListener('DOMContentLoaded', function () {
  const cursor = document.querySelector('.cursor');
  if (cursor) {
    setInterval(function () {
      cursor.style.opacity = cursor.style.opacity === '0' ? '1' : '0';
    }, 530);
  }
});
