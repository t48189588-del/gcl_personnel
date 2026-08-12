export default {
  async fetch(request: Request) {
    if (request.method !== 'POST') {
      return new Response(
        JSON.stringify({
          error: 'Method not allowed',
        }),
        {
          status: 405,
          headers: {
            'Content-Type': 'application/json',
          },
        },
      );
    }

    const powerAutomateUrl =
      process.env.POWER_AUTOMATE_URL_GET;

    if (!powerAutomateUrl) {
      console.error(
        'POWER_AUTOMATE_URL_GET is not configured.',
      );

      return new Response(
        JSON.stringify({
          error: 'Server configuration error',
        }),
        {
          status: 500,
          headers: {
            'Content-Type': 'application/json',
          },
        },
      );
    }

    try {
      const body = await request.text();

      const response = await fetch(
        powerAutomateUrl,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body,
        },
      );

      const responseText = await response.text();

      console.log(
        `Power Automate GET endpoint returned ${response.status}`,
      );

      return new Response(
        responseText || '{}',
        {
          status: response.status,
          headers: {
            'Content-Type':
              response.headers.get(
                'Content-Type',
              ) ?? 'application/json',
          },
        },
      );
    } catch (error) {
      console.error(
        'Power Automate booking fetch failed:',
        error,
      );

      return new Response(
        JSON.stringify({
          error:
            'Failed to contact booking service',
        }),
        {
          status: 502,
          headers: {
            'Content-Type':
              'application/json',
          },
        },
      );
    }
  },
};