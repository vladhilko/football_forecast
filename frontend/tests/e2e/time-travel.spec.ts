import { expect, test } from '@playwright/test'

test('registers, places winning and losing singles, reveals, and settles the wallet', async ({ page }, testInfo) => {
  test.setTimeout(75_000)
  test.skip(testInfo.project.name === 'mobile-chromium', 'The full timed settlement proof runs once on desktop')

  const email = `timeline-${Date.now()}-${testInfo.workerIndex}@example.test`

  await page.goto('/login')
  await page.getByLabel('Display name').fill('Timeline Explorer')
  await page.getByLabel('Email').fill(email)
  await page.getByLabel('Password').fill('timeline-password')
  await page.getByRole('button', { name: 'Create player account' }).click()

  await expect(page.getByLabel('10,000.00 play credits')).toBeVisible()
  await page.getByLabel('Target date').fill('2021-12-01')
  await page.getByRole('button', { name: 'Enter this timeline' }).click()
  await expect(page.getByRole('heading', { name: 'Next available round' })).toBeVisible()

  const fixtures = page.locator('.fixture-row')
  await fixtures.nth(0).getByRole('button', { name: /^1 / }).click() // Manchester United won 3–2.
  await fixtures.nth(1).getByRole('button', { name: /^2 / }).click() // Chelsea lost 2–3.
  await page.getByRole('button', { name: 'Place 2 singles' }).click()

  await expect(page.getByLabel('9,800.00 play credits')).toBeVisible()
  await page.getByRole('button', { name: /Move time forward/ }).click()
  await expect(page.getByText('Time is moving forward')).toBeVisible()
  await expect(page.getByText('Timeline resolved')).toBeVisible({ timeout: 55_000 })

  const summary = page.getByLabel('Settlement summary')
  await expect(summary).toContainText('200.00 CR')
  await expect(summary).toContainText('210.00 CR')
  await expect(summary).toContainText('+10.00 CR')
  await expect(summary).toContainText('10,010.00 CR')
})
