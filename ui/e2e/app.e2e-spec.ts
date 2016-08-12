import { UiPage } from './app.po';

describe('ui App', function() {
  let page: UiPage;

  beforeEach(() => {
    page = new UiPage();
  });

  it('should display the application title', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('SWD6 Character Cantina');
  });
});
