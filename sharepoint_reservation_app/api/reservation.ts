export async function POST(request: Request): Promise<Response> {
  const powerAutomateUrl = process.env.POWER_AUTOMATE_URL_POST;

  if (!powerAutomateUrl) {
    console.error('POWER_AUTOMATE_URL_POST is not configured.');

    return Response.json(
      {
        error: 'Server configuration error',
      },
      { status: 500 },
    );
  }

  try {
    const body = await request.text();

    const response = await fetch(powerAutomateUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body,
    });

    const responseText = await response.text();

    console.log(
      `Power Automate returned ${response.status}`,
    );

    return new Response(responseText || '{}', {
      status: response.status,
      headers: {
        'Content-Type':
          response.headers.get('Content-Type') ??
          'application/json',
      },
    });
  } catch (error) {
    console.error(
      'Power Automate request failed:',
      error,
    );

    return Response.json(
      {
        error: 'Failed to contact reservation service',
      },
      { status: 502 },
    );
  }
}