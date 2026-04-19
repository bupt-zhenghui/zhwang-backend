package collections;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

class BlockingQueueDemo {

    private static final ArrayBlockingQueue<Integer> queue = new ArrayBlockingQueue<>(5);

    public static void main(String[] args) throws InterruptedException {
        Thread producer = new Thread(() -> {
           for (int i = 0; i < 10; i++) {
               try {
                   queue.put(i);
                   System.out.println("produce element: " + i);
//                   Thread.sleep(200);
               } catch (InterruptedException e) {
                   Thread.currentThread().interrupt();
               }
           }
            System.out.println("produce done.");
        }, "Producer");

        Thread consumer = new Thread(() -> {
            while (true) {
                try {
                    Integer i = queue.take();
//                    Integer i = queue.poll(3, TimeUnit.SECONDS);
//                    if  (i == null) {
//                        System.out.println("consume timed out.");
//                        break;
//                    }
                    System.out.println("consume element: " + i);
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
            System.out.println("consume done.");
        }, "Consumer");

        producer.start();
        consumer.start();

        producer.join();
        Thread.sleep(1000);
        System.out.println("main thread exit.");
    }

}

