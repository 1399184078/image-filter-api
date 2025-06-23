import express from 'express';
import fetch from 'node-fetch';
import * as cv from 'opencv4nodejs';

const app = express();
app.use(express.json());

async function loadImageFromUrl(imageUrl: string): Promise<cv.Mat> {
  const response = await fetch(imageUrl);
  const buffer = await response.buffer();
  return cv.imdecode(buffer);
}

app.post('/filter', async (req, res) => {
  const { image_url, operation, kernel_size = 5 } = req.body;

  if (!image_url || !operation) {
    return res.status(400).json({ error: 'Missing required parameters.' });
  }

  try {
    const src = await loadImageFromUrl(image_url);
    let dst: cv.Mat;

    if (operation === 'mean') {
      dst = src.blur(new cv.Size(kernel_size, kernel_size));
    } else if (operation === 'median') {
      dst = src.medianBlur(kernel_size);
    } else {
      return res.status(400).json({ error: 'Unsupported operation.' });
    }

    const encoded = cv.imencode('.jpg', dst);
    res.json({
      image_base64: encoded.toString('base64'),
      message: `Applied ${operation} filter`
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Image processing failed.' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
