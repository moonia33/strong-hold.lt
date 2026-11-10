/**
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

import icons from '@helpers/icons';

const initVisiblePassword = () => {
  const {Theme} = window;
  const {visiblePassword: visiblePasswordMap} = Theme.selectors;
  const visiblePasswordList = document.querySelectorAll(visiblePasswordMap.visiblePassword);

  visiblePasswordList.forEach((button: HTMLButtonElement) => {
    const input = button?.previousElementSibling as HTMLElement;

    button?.addEventListener('click', () => {
      const newType = input.getAttribute('type') === 'text' ? 'password' : 'text';
      input.setAttribute('type', newType);

      const icon = button.firstElementChild;

      if (icon) {
        icon.outerHTML = newType === 'text' ? icons['eye-off'] : icons.eye;

        const {textHide, textShow} = button.dataset;

        if (textShow && textHide) {
          button.setAttribute('aria-label', newType === 'text' ? textHide : textShow);
        }
      }
    });
  });
};

export default initVisiblePassword;
