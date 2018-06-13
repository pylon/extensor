""" simple tensorflow graph

This graph computes the length of the hypotenuse of a right triangle, given
the lengths of the other two sides.

"""

import tensorflow as tf

a = tf.placeholder(tf.float32, name='a')
b = tf.placeholder(tf.float32, name='b')
c = tf.sqrt(tf.add(tf.square(a), tf.square(b)), name='c')

with tf.Session() as session:
    # save in frozen graph format, just a binary protocol buffer
    tf.train.write_graph(session.graph_def,
                         'test/data',
                         'pythagoras.pb',
                         as_text=False)

    # save in the saved_model format, which can include non-const variables
    tf.saved_model.simple_save(session,
                               'test/data/pythagoras',
                               inputs={'a': a, 'b': b},
                               outputs={'c': c})
